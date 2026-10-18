import { useQuery } from '@tanstack/react-query'
import { getJson } from '../../api/http'

/** Resposta de `/health/ready`: situação geral e de cada dependência (banco). */
export interface StatusApi {
  status: 'Healthy' | 'Degraded' | 'Unhealthy'
  totalDurationMs: number
  checks: { name: string; status: string; durationMs: number }[]
}

/** Situação da API e do banco. O health check não exige login. */
export function useStatusApi() {
  return useQuery({
    queryKey: ['status-api'],
    queryFn: ({ signal }) => getJson<StatusApi>('/health/ready', { signal }),
    refetchInterval: 60_000,
  })
}
