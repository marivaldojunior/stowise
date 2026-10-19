import { type FormEvent, useState } from 'react'
import { type Location, Navigate, useLocation, useNavigate } from 'react-router'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/features/auth/contexto'
import { Sparkles } from 'lucide-react'
import { Alerta, MensagemErro } from '@/components/Alerta'
import { Marca } from '@/components/Marca'
import { useTituloAba } from '@/lib/tituloAba'

/** Página pedida antes do login (RotaProtegida). Sem ela, o painel abre no início. */
function destino(location: Location): string {
  const de = (location.state as { de?: Location } | null)?.de
  return de ? `${de.pathname}${de.search}${de.hash}` : '/'
}

export function LoginPage() {
  const { status, entrar } = useAuth()
  const location = useLocation()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [senha, setSenha] = useState('')
  const [enviando, setEnviando] = useState(false)
  const [falha, setFalha] = useState<Falha | null>(null)
  useTituloAba('Entrar')

  if (status === 'autenticado' && !enviando) {
    return <Navigate to={destino(location)} replace />
  }

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setEnviando(true)
    setFalha(null)
    try {
      await entrar(email.trim(), senha)
      void navigate(destino(location), { replace: true })
    } catch (erro) {
      setFalha(falhaDe(erro, 'Erro inesperado ao entrar.'))
      setEnviando(false)
    }
  }

  const erroEmail = erroDoCampo(falha, 'email')
  const erroSenha = erroDoCampo(falha, 'senha')

  return (
    <main className="grid min-h-svh lg:grid-cols-[1.1fr_1fr]">
      <section className="relative isolate hidden flex-col justify-between overflow-hidden bg-grade-tinta p-10 text-white lg:flex">
        <div className="pointer-events-none absolute inset-0 -z-10 fundo-planta-clara" aria-hidden />
        <Marca className="text-white" />
        {/* Prateleira com etiquetas de endereço: o armazém que o Stowise organiza. */}
        <div className="pointer-events-none relative mx-auto my-8 w-full max-w-md" aria-hidden>
          <div className="grid grid-cols-4 gap-2">
            {Array.from({ length: 12 }, (_, indice) => (
              <span
                key={indice}
                className={
                  indice % 5 === 3
                    ? 'h-12 rounded-lg bg-grade-sinal opacity-90 shadow-lg'
                    : indice % 3 === 0
                      ? 'h-12 rounded-lg bg-white/8 ring-1 ring-white/10'
                      : 'h-12 rounded-lg bg-grade-marca opacity-90 shadow-lg'
                }
              />
            ))}
          </div>
          <span className="absolute -top-5 -right-3 flex rotate-3 items-center gap-2 rounded-lg bg-white px-3 py-2 font-mono text-xs text-[color:var(--tinta)] shadow-2xl">
            <span className="h-4 w-1 rounded-sm bg-sinal" />
            A-01-1-1
            <span className="h-4 w-14 codigo-de-barras" />
          </span>
          <span className="absolute -bottom-6 -left-2 flex -rotate-2 items-center gap-2 rounded-xl bg-grade-ia px-3 py-2 text-xs font-medium shadow-2xl brilho-ia">
            <Sparkles className="size-3.5" />
            Coluna "Unid" → Unidade base · 88%
          </span>
        </div>
        <div className="flex max-w-md flex-col gap-4">
          <p className="text-4xl leading-tight font-bold tracking-tight">
            Inventário e armazenagem <span className="texto-grade-ia">com IA</span>.
          </p>
          <ul className="flex flex-col gap-2.5 text-sm text-white/80">
            {[
              'Catálogo, endereços e estoque com histórico completo.',
              'Importação de produtos com o mapeamento sugerido pela IA.',
              'A IA só sugere: você confere antes de gravar.',
            ].map((texto) => (
              <li key={texto} className="flex items-start gap-2">
                <span className="mt-1.5 size-1.5 shrink-0 rounded-full bg-sinal" />
                {texto}
              </li>
            ))}
          </ul>
        </div>
        <p className="text-xs text-white/55">Projeto experimental de recursos de IA.</p>
      </section>
      <div className="relative isolate flex items-center justify-center p-4">
        <div className="pointer-events-none absolute inset-0 -z-10 fundo-planta [mask-image:radial-gradient(circle_at_center,black,transparent_70%)]" aria-hidden />
        <div className="flex w-full max-w-sm flex-col gap-6 rounded-3xl border border-border/70 bg-card/90 p-6 sombra-elevada backdrop-blur sm:p-8">
          <Marca className="lg:hidden" />
          <div className="flex flex-col gap-1">
            <h1 className="text-2xl font-bold tracking-tight">Entrar no Stowise</h1>
            <p className="text-sm text-muted-foreground">Use o e-mail e a senha da sua conta.</p>
          </div>
          <form className="flex flex-col gap-4" noValidate onSubmit={(evento) => void enviar(evento)}>
            <div className="flex flex-col gap-2">
              <Label htmlFor="email">E-mail</Label>
              <Input
                id="email"
                type="email"
                autoComplete="username"
                required
                value={email}
                onChange={(evento) => setEmail(evento.target.value)}
                aria-invalid={erroEmail ? true : undefined}
                aria-describedby={erroEmail ? 'email-erro' : undefined}
              />
              {erroEmail && (
                <p id="email-erro" className="text-sm text-destructive">
                  {erroEmail}
                </p>
              )}
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="senha">Senha</Label>
              <Input
                id="senha"
                type="password"
                autoComplete="current-password"
                required
                value={senha}
                onChange={(evento) => setSenha(evento.target.value)}
                aria-invalid={erroSenha ? true : undefined}
                aria-describedby={erroSenha ? 'senha-erro' : undefined}
              />
              {erroSenha && (
                <p id="senha-erro" className="text-sm text-destructive">
                  {erroSenha}
                </p>
              )}
            </div>
            {falha && <MensagemErro>{falha.mensagem}</MensagemErro>}
            <Button type="submit" disabled={enviando}>
              {enviando ? 'Entrando…' : 'Entrar'}
            </Button>
          </form>
          {import.meta.env.MODE === 'demo' && (
            <Alerta tom="info">
              Modo demonstração: entre com admin@, gestor@ ou operador@stowise.dev e qualquer senha.
            </Alerta>
          )}
        </div>
      </div>
    </main>
  )
}
