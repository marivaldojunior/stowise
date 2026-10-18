import { HttpError } from './mutator'

/** Erro de uma chamada, pronto para a tela: mensagem geral e erros por campo (nome do campo em camelCase). */
export interface Falha {
  mensagem: string
  campos: Record<string, string[]>
}

/**
 * Converte o erro da API numa mensagem para o usuário. Regras de negócio (422, 409) trazem a mensagem no title;
 * erros de validação (400) trazem os campos. Sem resposta (status 0), o detail é o erro técnico do navegador e fica
 * de fora.
 */
export function falhaDe(erro: unknown, padrao = 'Erro inesperado. Tente de novo.'): Falha {
  if (!(erro instanceof HttpError)) {
    return { mensagem: padrao, campos: {} }
  }

  const campos = erro.problem?.errors ?? {}
  if (Object.keys(campos).length > 0) {
    return { mensagem: 'Confira os campos destacados.', campos }
  }

  return { mensagem: erro.status === 0 ? erro.message : (erro.problem?.detail ?? erro.message), campos }
}

/** Primeiro erro de um campo, aceitando o nome em PascalCase que o ASP.NET às vezes devolve. */
export function erroDoCampo(falha: Falha | null, campo: string): string | undefined {
  if (!falha) {
    return undefined
  }

  const pascal = campo.charAt(0).toUpperCase() + campo.slice(1)
  return (falha.campos[campo] ?? falha.campos[pascal])?.[0]
}
