import { Layers, Map as MapaIcone, Plus, Rows3 } from 'lucide-react'
import { useState } from 'react'
import { falhaDe } from '@/api/falha'
import { useListarArmazens, useListarEnderecos, useObterArmazem } from '@/api/gerado/stowise'
import type { EnderecoDetalhe, ListarEnderecosParams, StatusEndereco } from '@/api/gerado/modelos'
import { Paginacao } from '@/components/Paginacao'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { ROTULO_CLASSE } from '@/features/catalogo/rotulos'
import { GerarEmLote, NovoEndereco } from '@/features/enderecos/CadastroEnderecos'
import { DetalheEndereco } from '@/features/enderecos/DetalheEndereco'
import { ROTULO_STATUS, TOM_STATUS, useMapaEnderecos } from '@/features/enderecos/mapa'
import { MapaOcupacao } from '@/features/enderecos/MapaOcupacao'
import { TODOS, useBusca, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'
import { cn } from '@/lib/utils'
import { LinhaVazia, LinhasCarregando } from '@/components/EstadoTabela'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Situacao } from '@/components/Situacao'

const TAMANHO_PAGINA = 50

type Dialogo = { tipo: 'detalhe'; endereco: EnderecoDetalhe } | { tipo: 'novo' | 'lote' } | null

function ListaEnderecos({ zonaId, onSelecionar }: { zonaId: string; onSelecionar: (e: EnderecoDetalhe) => void }) {
  const url = useFiltrosDaUrl()
  const filtros: ListarEnderecosParams = {
    zonaId,
    codigo: url.texto('codigo'),
    status: url.texto('status') as StatusEndereco | undefined,
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const [codigo, setCodigo] = useBusca(filtros.codigo, (valor) => url.mudar('codigo', valor))
  const lista = useListarEnderecos(filtros, { query: { placeholderData: (anterior) => anterior } })

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-wrap gap-2">
        <Input
          type="search"
          aria-label="Buscar pelo código"
          placeholder="Código (ex.: A-01)"
          className="w-full sm:w-56"
          value={codigo}
          onChange={(e) => setCodigo(e.target.value)}
        />
        <Select value={filtros.status ?? TODOS} onValueChange={(valor) => url.mudar('status', valor)}>
          <SelectTrigger aria-label="Filtrar por situação" className="w-40">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todas as situações</SelectItem>
            {(Object.keys(ROTULO_STATUS) as StatusEndereco[]).map((status) => (
              <SelectItem key={status} value={status}>
                {ROTULO_STATUS[status]}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      {lista.isError ? (
        <Alerta tom="erro">Não foi possível carregar os endereços: {falhaDe(lista.error).mensagem}</Alerta>
      ) : (
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Código</TableHead>
                <TableHead>Situação</TableHead>
                <TableHead>Capacidade</TableHead>
                <TableHead>Dimensões (A × L × P)</TableHead>
                <TableHead>Distância</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <LinhasCarregando colunas={5} rotulo="Carregando os endereços" />
              ) : lista.data.itens.length === 0 ? (
                <LinhaVazia colunas={5} texto="Nenhum endereço encontrado." />
              ) : (
                lista.data.itens.map((endereco) => (
                  <TableRow key={endereco.id}>
                    <TableCell>
                      <button
                        type="button"
                        className="font-mono text-xs hover:underline"
                        onClick={() => onSelecionar(endereco)}
                      >
                        {endereco.codigo}
                      </button>
                    </TableCell>
                    <TableCell>
                      <Situacao tom={TOM_STATUS[endereco.status]}>{ROTULO_STATUS[endereco.status]}</Situacao>
                    </TableCell>
                    <TableCell>{formatarNumero(endereco.capacidadePesoKg, 'kg')}</TableCell>
                    <TableCell>
                      {formatarNumero(endereco.alturaCm)} × {formatarNumero(endereco.larguraCm)} ×{' '}
                      {formatarNumero(endereco.profundidadeCm, 'cm')}
                    </TableCell>
                    <TableCell>{formatarNumero(endereco.distanciaExpedicao, 'm')}</TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      )}
      <Paginacao lista={lista.data} rotulo="endereço(s)" onPagina={(p) => url.mudar('pagina', String(p))} />
    </div>
  )
}

/** Endereços por armazém e zona: mapa de ocupação ou lista, cadastro avulso e geração em lote (gestão). */
export function EnderecosPage() {
  const { temPerfil } = useAuth()
  const url = useFiltrosDaUrl()
  const [dialogo, setDialogo] = useState<Dialogo>(null)
  const armazens = useListarArmazens()
  const armazemId = url.texto('armazemId') ?? armazens.data?.[0]?.id
  const armazem = useObterArmazem(armazemId ?? '', { query: { enabled: Boolean(armazemId) } })
  const zonaId = url.texto('zonaId') ?? armazem.data?.zonas[0]?.id
  const zona = armazem.data?.zonas.find((z) => z.id === zonaId)
  const visao = url.texto('visao') === 'lista' ? 'lista' : 'mapa'
  const mapa = useMapaEnderecos(visao === 'mapa' ? zonaId : undefined)

  function trocarArmazem(id: string) {
    url.mudarVarios({ armazemId: id, zonaId: undefined })
  }

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo="Endereços"
        descricao="Posições de armazenagem por armazém e zona."
        acoes={
          temPerfil(...PERFIS_GESTAO) &&
          zona && (
            <>
              <Button variant="outline" onClick={() => setDialogo({ tipo: 'novo' })}>
                <Plus /> Novo endereço
              </Button>
              <Button onClick={() => setDialogo({ tipo: 'lote' })}>
                <Layers /> Gerar em lote
              </Button>
            </>
          )
        }
      />

      {armazens.data?.length === 0 ? (
        <Alerta tom="info">Nenhum armazém cadastrado.</Alerta>
      ) : (
        <div className="flex flex-wrap items-center gap-2">
          <Select value={armazemId ?? ''} onValueChange={trocarArmazem}>
            <SelectTrigger aria-label="Armazém" className="w-full sm:w-80">
              <SelectValue placeholder="Armazém" />
            </SelectTrigger>
            <SelectContent>
              {(armazens.data ?? []).map((a) => (
                <SelectItem key={a.id} value={a.id}>
                  {a.codigo} · {a.nome}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select value={zonaId ?? ''} onValueChange={(valor) => url.mudar('zonaId', valor)}>
            <SelectTrigger aria-label="Zona" className="w-56">
              <SelectValue placeholder="Zona" />
            </SelectTrigger>
            <SelectContent>
              {(armazem.data?.zonas ?? []).map((z) => (
                <SelectItem key={z.id} value={z.id}>
                  {z.codigo} · {ROTULO_CLASSE[z.classeArmazenagem]} ({z.enderecos})
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <div className="ml-auto flex rounded-md border p-0.5" role="group" aria-label="Visão">
            {(
              [
                ['mapa', 'Mapa', MapaIcone],
                ['lista', 'Lista', Rows3],
              ] as const
            ).map(([valor, rotulo, Icone]) => (
              <Button
                key={valor}
                size="sm"
                variant="ghost"
                aria-pressed={visao === valor}
                className={cn(visao === valor && 'bg-muted')}
                onClick={() => url.mudar('visao', valor === 'mapa' ? undefined : valor)}
              >
                <Icone /> {rotulo}
              </Button>
            ))}
          </div>
        </div>
      )}

      {armazem.data && armazem.data.zonas.length === 0 && (
        <Alerta tom="info">Este armazém ainda não tem zonas.</Alerta>
      )}

      {zonaId &&
        (visao === 'mapa' ? (
          mapa.isError ? (
            <Alerta tom="erro">Não foi possível carregar o mapa: {falhaDe(mapa.error).mensagem}</Alerta>
          ) : (
            <MapaOcupacao
              enderecos={mapa.data}
              carregando={mapa.isPending}
              onSelecionar={(endereco) => setDialogo({ tipo: 'detalhe', endereco })}
            />
          )
        ) : (
          <ListaEnderecos zonaId={zonaId} onSelecionar={(endereco) => setDialogo({ tipo: 'detalhe', endereco })} />
        ))}

      {dialogo?.tipo === 'detalhe' && <DetalheEndereco endereco={dialogo.endereco} onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'novo' && zona && <NovoEndereco zona={zona} onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'lote' && zona && <GerarEmLote zona={zona} onFechar={() => setDialogo(null)} />}
    </section>
  )
}
