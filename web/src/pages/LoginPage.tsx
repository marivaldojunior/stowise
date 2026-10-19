import { type FormEvent, useState } from 'react'
import { type Location, Navigate, useLocation, useNavigate } from 'react-router'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/features/auth/contexto'
import { Boxes } from 'lucide-react'
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
      <section className="hidden flex-col justify-between bg-primary p-10 text-primary-foreground lg:flex dark:border-r dark:bg-primary/10 dark:text-foreground">
        <span className="flex items-center gap-2 text-lg font-semibold">
          <span className="flex size-8 items-center justify-center rounded-lg bg-primary-foreground/15 dark:bg-primary dark:text-primary-foreground">
            <Boxes className="size-5" aria-hidden />
          </span>
          Stowise
        </span>
        <div className="flex max-w-md flex-col gap-4">
          <p className="text-3xl leading-tight font-semibold">Inventário e armazenagem com IA.</p>
          <ul className="flex flex-col gap-2 text-sm opacity-85">
            <li>Catálogo, endereços e estoque com histórico completo.</li>
            <li>Importação de produtos com o mapeamento sugerido pela IA.</li>
            <li>A IA só sugere: você confere antes de gravar.</li>
          </ul>
        </div>
        <p className="text-xs opacity-70">Projeto experimental de recursos de IA.</p>
      </section>
      <div className="flex items-center justify-center p-4">
        <div className="flex w-full max-w-sm flex-col gap-6">
          <Marca className="lg:hidden" />
          <div className="flex flex-col gap-1">
            <h1 className="text-2xl font-semibold tracking-tight">Entrar no Stowise</h1>
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
