using Stowise.Domain.Common;
using Stowise.Domain.Ia;

namespace Stowise.UnitTests.Ia;

public class ChamadaIaTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);

    [Fact]
    public void Successful_call_keeps_the_measurements()
    {
        var usuario = Guid.NewGuid();

        var chamada = ChamadaIa.Create(
            FuncionalidadeIa.Mapeamento, usuario, "Anthropic", "claude-opus-5-5", "mapeamento-v1", new UsoIa(1200, 300, 850), 0.0108m, null, "trace-1", Agora);

        Assert.True(chamada.Sucesso);
        Assert.Null(chamada.Erro);
        Assert.Equal((1200, 300, 850, 1, false), (chamada.TokensEntrada, chamada.TokensSaida, chamada.LatenciaMs, chamada.Tentativas, chamada.UsouFallback));
        Assert.Equal((usuario, 0.0108m, "trace-1", Agora), (chamada.UsuarioId, chamada.CustoEstimado, chamada.CorrelacaoId, chamada.CriadaEm));
    }

    [Fact]
    public void Failed_call_is_recorded_with_a_bounded_error()
    {
        var chamada = ChamadaIa.Create(
            FuncionalidadeIa.Consulta, null, "Ollama", "llama3.2", "consulta-v1", new UsoIa(null, null, 30_000, Tentativas: 3, UsouFallback: true), null, new string('x', 2000), null, Agora);

        Assert.False(chamada.Sucesso);
        Assert.Equal(ChamadaIa.ErroMaxLength, chamada.Erro!.Length);
        Assert.Equal((3, true), (chamada.Tentativas, chamada.UsouFallback));
    }

    [Fact]
    public void Call_needs_provider_model_prompt_version_and_valid_measurements()
    {
        ChamadaIa Create(string provedor, UsoIa uso) =>
            ChamadaIa.Create(FuncionalidadeIa.Mapeamento, null, provedor, "m", "v1", uso, null, null, null, Agora);

        Assert.Throws<DomainException>(() => Create(" ", new UsoIa(1, 1, 1)));
        Assert.Throws<ArgumentOutOfRangeException>(() => Create("Anthropic", new UsoIa(1, 1, -1)));
        Assert.Throws<ArgumentOutOfRangeException>(() => Create("Anthropic", new UsoIa(1, 1, 1, Tentativas: 0)));
    }
}
