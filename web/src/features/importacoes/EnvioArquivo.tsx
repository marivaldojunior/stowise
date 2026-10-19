import { useQueryClient } from '@tanstack/react-query'
import { FileUp } from 'lucide-react'
import { type DragEvent, useRef, useState } from 'react'
import { useNavigate } from 'react-router'
import { falhaDe } from '@/api/falha'
import { getListarImportacoesQueryKey, getObterImportacaoQueryKey, useImportarProdutos } from '@/api/gerado/stowise'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

/** Tipos aceitos pela API: texto delimitado ou posicional e planilha do Excel. */
const ACEITOS = '.csv,.txt,.xlsx'

/** Envio de um arquivo de produtos, por clique ou arrastando. Depois do envio, abre a importação. */
export function EnvioArquivo() {
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const entrada = useRef<HTMLInputElement>(null)
  const importar = useImportarProdutos()
  const [arrastando, setArrastando] = useState(false)
  const [erro, setErro] = useState<string | null>(null)

  async function enviar(arquivo: File | undefined) {
    if (!arquivo) {
      return
    }

    setErro(null)
    try {
      const importacao = await importar.mutateAsync({ data: { arquivo } })
      queryClient.setQueryData(getObterImportacaoQueryKey(importacao.id), importacao)
      await queryClient.invalidateQueries({ queryKey: getListarImportacoesQueryKey() })
      void navigate(`/importacoes/${importacao.id}`)
    } catch (falha) {
      setErro(falhaDe(falha).mensagem)
    } finally {
      if (entrada.current) {
        entrada.current.value = ''
      }
    }
  }

  function soltar(evento: DragEvent<HTMLDivElement>) {
    evento.preventDefault()
    setArrastando(false)
    void enviar(evento.dataTransfer.files[0])
  }

  return (
    <div className="flex flex-col gap-2">
      <div
        onDragOver={(e) => {
          e.preventDefault()
          setArrastando(true)
        }}
        onDragLeave={() => setArrastando(false)}
        onDrop={soltar}
        className={cn(
          'flex flex-col items-center gap-3 rounded-lg border-2 border-dashed p-8 text-center transition-colors',
          arrastando && 'border-primary bg-primary/5',
        )}
      >
        <FileUp className="size-8 text-muted-foreground" aria-hidden />
        <p className="text-sm text-muted-foreground">
          Arraste um arquivo de produtos (CSV, TXT ou Excel) para cá, ou escolha no computador.
        </p>
        <input
          ref={entrada}
          type="file"
          accept={ACEITOS}
          className="sr-only"
          aria-label="Arquivo de produtos"
          onChange={(e) => void enviar(e.target.files?.[0])}
        />
        <Button disabled={importar.isPending} onClick={() => entrada.current?.click()}>
          {importar.isPending ? 'Enviando…' : 'Escolher arquivo'}
        </Button>
      </div>
      {erro && (
        <p role="alert" className="text-sm text-destructive">
          {erro}
        </p>
      )}
    </div>
  )
}
