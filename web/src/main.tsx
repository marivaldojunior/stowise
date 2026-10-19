import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

/** No modo demonstração, o MSW responde no navegador antes de o painel fazer a primeira chamada. */
async function prepararDemonstracao() {
  if (import.meta.env.MODE === 'demo') {
    const { iniciarDemonstracao } = await import('./demo/navegador')
    await iniciarDemonstracao()
  }
}

void prepararDemonstracao().then(() =>
  createRoot(document.getElementById('root')!).render(
    <StrictMode>
      <App />
    </StrictMode>,
  ),
)
