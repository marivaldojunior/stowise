# Schemas da NF-e 4.00

Arquivos oficiais do Portal Nacional da NF-e (Esquemas XML, versões em uso), sem alteração de conteúdo (o Git só normaliza o fim de linha):

- **Pacote:** Schemas XML NF-e - Pacote de Liberação nº 010f (pasta `PL_010f_v1.04`), NT 2025.002 v.1.50 e NT 2026.007 v.1.00, publicado em 31/08/2026.
- **Origem:** https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=BMPFMBoln3w= (baixado em 20/10/2026).
- **SHA-256 do ZIP:** `b8589490a58a09a993a80e6ac4d7ed10f20892061ecfc56719337098d4b95998`.

O pacote não traz o `procNFe_v4.00.xsd`: o `ValidadorSchemaNfe` valida o elemento `NFe` pelo `nfe_v4.00.xsd`, e o `LeitorNfe` confere o protocolo (chave e `cStat`).

Para atualizar: baixe o pacote novo do portal, troque os arquivos desta pasta, atualize este README e rode os testes de `NotasFiscais`.
