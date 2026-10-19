import { LogOut, UserRound } from 'lucide-react'
import { useNavigate } from 'react-router'
import { Situacao } from '@/components/Situacao'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useAuth } from '@/features/auth/contexto'

function iniciais(nome: string): string {
  const partes = nome.trim().split(/\s+/)
  return ((partes[0]?.[0] ?? '') + (partes.length > 1 ? (partes.at(-1)?.[0] ?? '') : '')).toUpperCase()
}

/** Nome, e-mail e perfis do usuário, com a saída do painel. */
export function MenuUsuario() {
  const { usuario, sair } = useAuth()
  const navigate = useNavigate()
  if (!usuario) {
    return null
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" className="gap-2 px-2" aria-label="Menu do usuário">
          <span className="flex size-7 items-center justify-center rounded-full bg-primary/12 text-xs font-semibold text-primary">
            {iniciais(usuario.nome) || <UserRound className="size-4" />}
          </span>
          <span className="hidden max-w-40 truncate text-sm font-normal sm:inline" aria-hidden>
            {usuario.nome}
          </span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel className="flex flex-col gap-1">
          <span className="text-sm font-medium text-foreground">{usuario.nome}</span>
          <span className="truncate text-xs font-normal">{usuario.email}</span>
          <span className="flex flex-wrap gap-1">
            {usuario.perfis.map((perfil) => (
              <Situacao key={perfil} tom="marca">
                {perfil}
              </Situacao>
            ))}
          </span>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        {/* Sem guardar a página atual: quem entrar depois (talvez outro usuário) começa no início. */}
        <DropdownMenuItem onSelect={() => void sair().then(() => navigate('/login', { replace: true }))}>
          <LogOut /> Sair
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
