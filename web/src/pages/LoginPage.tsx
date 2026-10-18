import { type FormEvent, useState } from 'react'
import { type Location, Navigate, useLocation, useNavigate } from 'react-router'
import { HttpError } from '@/api/mutator'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/features/auth/contexto'

interface Falha {
  mensagem: string
  campos: Record<string, string[]>
}

function falhaDe(erro: unknown): Falha {
  if (erro instanceof HttpError) {
    const campos = erro.problem?.errors ?? {}
    // Sem resposta (status 0), o detail traz o erro técnico do navegador; a mensagem do erro já explica o problema.
    const mensagem =
      Object.keys(campos).length > 0
        ? 'Confira os campos destacados.'
        : erro.status === 0
          ? erro.message
          : (erro.problem?.detail ?? erro.message)
    return { mensagem, campos }
  }

  return { mensagem: 'Erro inesperado ao entrar.', campos: {} }
}

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
      setFalha(falhaDe(erro))
      setEnviando(false)
    }
  }

  const erroEmail = falha?.campos.email?.[0]
  const erroSenha = falha?.campos.senha?.[0]

  return (
    <main className="flex min-h-svh items-center justify-center p-4">
      <Card className="w-full max-w-sm">
        <CardHeader>
          <CardTitle className="text-xl">Entrar no Stowise</CardTitle>
          <CardDescription>Use o e-mail e a senha da sua conta.</CardDescription>
        </CardHeader>
        <CardContent>
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
            {falha && (
              <p role="alert" className="text-sm text-destructive">
                {falha.mensagem}
              </p>
            )}
            <Button type="submit" disabled={enviando}>
              {enviando ? 'Entrando…' : 'Entrar'}
            </Button>
          </form>
        </CardContent>
      </Card>
    </main>
  )
}
