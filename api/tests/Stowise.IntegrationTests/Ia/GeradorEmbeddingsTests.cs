using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Gerador de embeddings (ADR-0011): dimensões conferidas, nova tentativa só em falha transitória e registro. Sem banco.</summary>
public class GeradorEmbeddingsTests
{
    private readonly RegistroEmMemoria _registro = new();

    [Fact]
    public async Task Generates_one_vector_per_text_and_records_the_call_without_user()
    {
        var gerador = Criar(new FakeEmbeddingGenerator());

        var vetores = await gerador.GenerateAsync(["Refrigerante Cola 2L", "Água mineral"], CancellationToken.None);

        Assert.NotNull(vetores);
        Assert.Equal(2, vetores.Count);
        Assert.All(vetores, v => Assert.Equal(EmbeddingsIaOptions.Dimensoes, v.Length));
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal(FuncionalidadeIa.Embeddings, chamada.Funcionalidade);
        Assert.Null(chamada.UsuarioId);
        Assert.True(chamada.Sucesso);
        Assert.Equal(GeradorEmbeddings.PromptVersao, chamada.PromptVersao);
    }

    [Fact]
    public async Task Retries_a_transient_failure()
    {
        var fake = new FakeEmbeddingGenerator(falhas: 1);
        var gerador = Criar(fake);

        var vetores = await gerador.GenerateAsync(["Café 500g"], CancellationToken.None);

        Assert.NotNull(vetores);
        Assert.Equal(2, fake.Chamadas);
        Assert.Equal(2, Assert.Single(_registro.Chamadas).Tentativas);
    }

    [Fact]
    public async Task Permanent_failure_returns_null_without_retrying()
    {
        var fake = new FakeEmbeddingGenerator(falhas: 5, erro: new InvalidOperationException("modelo inexistente"));
        var gerador = Criar(fake);

        Assert.Null(await gerador.GenerateAsync(["Café 500g"], CancellationToken.None));
        Assert.Equal(1, fake.Chamadas);
        Assert.False(Assert.Single(_registro.Chamadas).Sucesso);
    }

    [Fact]
    public async Task Vectors_with_other_dimensions_are_refused()
    {
        var gerador = Criar(new FakeEmbeddingGenerator(dimensoes: 384));

        Assert.Null(await gerador.GenerateAsync(["Café 500g"], CancellationToken.None));
        Assert.Contains("768 dimensions", Assert.Single(_registro.Chamadas).Erro, StringComparison.Ordinal);
    }

    [Fact]
    public async Task Disabled_generator_does_nothing()
    {
        var options = Options.Create(new IaOptions { Habilitada = true });
        using var gerador = new GeradorEmbeddings(options, [new OllamaFabrica()], _registro, TimeProvider.System, NullLogger<GeradorEmbeddings>.Instance);

        Assert.False(gerador.Disponivel);
        Assert.Null(await gerador.GenerateAsync(["Café"], CancellationToken.None));
        Assert.Empty(_registro.Chamadas);
    }

    private GeradorEmbeddings Criar(FakeEmbeddingGenerator fake) =>
        new(fake, new EmbeddingsIaOptions { Habilitado = true, Tipo = "Ollama", Modelo = "fake", TimeoutSegundos = 5 }, _registro, TimeProvider.System, NullLogger<GeradorEmbeddings>.Instance);
}
