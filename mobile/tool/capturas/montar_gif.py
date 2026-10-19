"""Monta docs/media/app.gif com as capturas do app (docs/media/app-*.png) e apaga as capturas.

Uso (em mobile/), depois de `flutter test tool/capturas`:
    python tool/capturas/montar_gif.py

Precisa do Pillow (pip install pillow).
"""

import pathlib

from PIL import Image

PASTA = pathlib.Path(__file__).resolve().parents[3] / 'docs' / 'media'
LARGURA = 360
DURACAO_MS = 2200

capturas = sorted(PASTA.glob('app-*.png'))
if not capturas:
    raise SystemExit('Nenhuma captura em docs/media. Rode antes: flutter test tool/capturas')

quadros = []
for arquivo in capturas:
    imagem = Image.open(arquivo).convert('RGB')
    altura = round(imagem.height * LARGURA / imagem.width)
    imagem = imagem.resize((LARGURA, altura), Image.Resampling.LANCZOS)
    quadros.append(imagem.quantize(colors=128, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE))

destino = PASTA / 'app.gif'
quadros[0].save(destino, save_all=True, append_images=quadros[1:], duration=DURACAO_MS, loop=0, optimize=True)
for arquivo in capturas:
    arquivo.unlink()

print(f'{destino} ({destino.stat().st_size // 1024} KB, {len(quadros)} telas)')
