import { type HubConnection, HubConnectionBuilder, HubConnectionState, LogLevel } from '@microsoft/signalr'
import { useQueryClient } from '@tanstack/react-query'
import { useEffect, useState } from 'react'
import { getObterImportacaoQueryKey, getObterRelatorioImportacaoQueryKey } from '@/api/gerado/stowise'
import type { ImportacaoDetalhe, StatusImportacao } from '@/api/gerado/modelos'
import { getSessao } from '@/features/auth/sessao'

/** Evento `progresso` do hub /hubs/importacoes (ProgressoImportacao na API). */
export interface ProgressoImportacao {
  id: string
  status: StatusImportacao
  totalLinhas: number
  linhasProcessadas: number
  linhasValidas: number
  linhasComErro: number
  linhasPossivelDuplicata: number
  motivoFalha: string | null
}

/** Aplica o progresso à importação em cache. Devolve se o status mudou (aí a tela recarrega o detalhe completo). */
export function aplicarProgresso(
  atual: ImportacaoDetalhe | undefined,
  progresso: ProgressoImportacao,
): { importacao: ImportacaoDetalhe | undefined; mudouStatus: boolean } {
  if (!atual) {
    return { importacao: atual, mudouStatus: true }
  }

  const { id: _id, ...campos } = progresso
  return { importacao: { ...atual, ...campos }, mudouStatus: atual.status !== progresso.status }
}

/**
 * Acompanha a importação pelo SignalR enquanto `ativo`: cada evento atualiza o cache, e a troca de status recarrega o
 * detalhe e o relatório. O token vai em access_token (WebSocket não envia cabeçalho). Devolve se está conectado; sem
 * conexão, a tela usa a consulta periódica.
 */
export function useProgressoImportacao(id: string, ativo: boolean): boolean {
  const queryClient = useQueryClient()
  const [conectado, setConectado] = useState(false)

  useEffect(() => {
    if (!ativo) {
      return
    }

    let encerrado = false
    const conexao: HubConnection = new HubConnectionBuilder()
      .withUrl('/hubs/importacoes', { accessTokenFactory: () => getSessao()?.accessToken ?? '' })
      .withAutomaticReconnect()
      .configureLogging(LogLevel.Warning)
      .build()

    conexao.on('progresso', (progresso: ProgressoImportacao) => {
      if (progresso.id !== id) {
        return
      }

      const chave = getObterImportacaoQueryKey(id)
      const { importacao, mudouStatus } = aplicarProgresso(queryClient.getQueryData<ImportacaoDetalhe>(chave), progresso)
      queryClient.setQueryData(chave, importacao)
      if (mudouStatus) {
        void queryClient.invalidateQueries({ queryKey: chave })
        void queryClient.invalidateQueries({ queryKey: getObterRelatorioImportacaoQueryKey(id) })
      }
    })
    conexao.onreconnecting(() => setConectado(false))
    conexao.onreconnected(() => {
      setConectado(true)
      // Depois de reconectar, o servidor não lembra o grupo: entra de novo e busca o que mudou no intervalo.
      void conexao.invoke('Acompanhar', id)
      void queryClient.invalidateQueries({ queryKey: getObterImportacaoQueryKey(id) })
    })
    conexao.onclose(() => setConectado(false))

    void conexao
      .start()
      .then(() => conexao.invoke('Acompanhar', id))
      .then(() => {
        if (!encerrado) {
          setConectado(true)
          // Eventos enviados antes de entrar no grupo se perdem: busca o estado atual uma vez.
          void queryClient.invalidateQueries({ queryKey: getObterImportacaoQueryKey(id) })
        }
      })
      .catch(() => setConectado(false))

    return () => {
      encerrado = true
      setConectado(false)
      if (conexao.state === HubConnectionState.Connected) {
        void conexao.invoke('Deixar', id).catch(() => undefined)
      }

      void conexao.stop()
    }
  }, [id, ativo, queryClient])

  return conectado
}
