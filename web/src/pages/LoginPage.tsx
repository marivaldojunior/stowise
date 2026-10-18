import { type FormEvent, useState } from 'react'
import { type Location, Navigate, useLocation, useNavigate } from 'react-router'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/features/auth/contexto'

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
      setFalha(falhaDe(erro, 'Erro inesperado ao entrar.'))
      setEnviando(false)
    }
  }

  const erroEmail = erroDoCampo(falha, 'email')
  const erroSenha = erroDoCampo(falha, 'senha')

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
