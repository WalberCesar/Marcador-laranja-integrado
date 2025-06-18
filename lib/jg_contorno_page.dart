import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'estilos.dart';

class JogoContorno extends StatefulWidget {
  const JogoContorno({super.key});

  @override
  State<JogoContorno> createState() => _JogoContornoState();
}

class _JogoContornoState extends State<JogoContorno> {
  final List<Offset> _pontos = [];
  final List<String> _letras = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );
  late String _letraAtual;
  bool _venceu = false;
  int _pontuacao = 0;

  ui.Image? _imageLetra; // imagem da letra para manipulação
  ByteData? _byteData; // dados da imagem para manipulação pixel a pixel
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _sortearLetra();
  }

  void _sortearLetra() async {
    final random = Random();
    _letraAtual = _letras[random.nextInt(_letras.length)];
    _pontos.clear();
    _venceu = false;
    _imageLetra = null;
    _byteData = null;
    setState(() {});
    await _gerarImagemLetra(_letraAtual);
  }

  Future<void> _gerarImagemLetra(String letra) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final size = Size(300, 300);

    // Fundo transparente
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.transparent,
    );

    // Para evitar inversão no APK, inverta o eixo Y aqui (desenhe “normal”)
    // Se ainda estiver invertido, comente essa linha
    //canvas.translate(0, size.height);
    //canvas.scale(1, -1);

    // Desenha a letra preta no centro
    final textPainter = TextPainter(
      text: TextSpan(
        text: letra,
        style: TextStyle(color: Colors.black, fontSize: 250),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);

    setState(() {
      _imageLetra = img;
      _byteData = byteData;
    });
  }

  void _onTouch(Offset localPosition) async {
    if (_processing || _venceu || _imageLetra == null || _byteData == null)
      return;

    _processing = true;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final widgetSize = box.size;

    final scaleX = _imageLetra!.width / widgetSize.width;
    final scaleY = _imageLetra!.height / widgetSize.height;

    final px = (localPosition.dx * scaleX).toInt();
    final py = (localPosition.dy * scaleY).toInt();

    if (px < 0 ||
        py < 0 ||
        px >= _imageLetra!.width ||
        py >= _imageLetra!.height) {
      _processing = false;
      return;
    }

    const int raio = 25;

    final int width = _imageLetra!.width;
    final data = _byteData!;

    for (
      int dy = max(py - raio, 0);
      dy < min(py + raio, _imageLetra!.height);
      dy++
    ) {
      for (int dx = max(px - raio, 0); dx < min(px + raio, width); dx++) {
        final int index = (dy * width + dx) * 4;

        final r = data.getUint8(index);
        final g = data.getUint8(index + 1);
        final b = data.getUint8(index + 2);
        final a = data.getUint8(index + 3);

        if (r == 0 && g == 0 && b == 0 && a > 0) {
          data.setUint8(index, 255);
          data.setUint8(index + 1, 140);
          data.setUint8(index + 2, 0);
          data.setUint8(index + 3, a);
        }
      }
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      data.buffer.asUint8List(),
      width,
      _imageLetra!.height,
      ui.PixelFormat.rgba8888,
      (result) {
        completer.complete(result);
      },
    );
    final newImage = await completer.future;

    final newByteData = await newImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );

    setState(() {
      _imageLetra = newImage;
      _byteData = newByteData;
      _pontos.add(localPosition);
    });

    bool temPreto = false;
    for (int i = 0; i < data.lengthInBytes; i += 4) {
      final r = data.getUint8(i);
      final g = data.getUint8(i + 1);
      final b = data.getUint8(i + 2);
      final a = data.getUint8(i + 3);
      if (r == 0 && g == 0 && b == 0 && a > 0) {
        temPreto = true;
        break;
      }
    }

    if (!temPreto) {
      _venceu = true;
      _pontuacao += 15;
      _mostrarDialogoVitoria();
    }

    _processing = false;
  }

  void _mostrarDialogoVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text('Parabéns!'),
            content: Text('Você contornou a letra corretamente!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sortearLetra();
                },
                child: Text('Jogar Novamente'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text('Sair'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: estiloDrawerHeader,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nome da Criança', style: estiloNomeCrianca),
                  Text('Pontuação: $_pontuacao', style: estiloPontuacao),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.arrow_left_rounded,
                color: estiloListTileIcone,
              ),
              title: Text('Voltar', style: estiloListTileTexto),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tema Escuro',
                    style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                  ),
                  CustomSwitch(),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: estiloBordaAppBar,
          child: AppBar(
            title: Text('Contorne a Letra'),
            iconTheme: estiloAppBar.iconTheme,
            backgroundColor: estiloAppBar.backgroundColor,
            elevation: estiloAppBar.elevation,
            titleTextStyle: estiloAppBar.titleTextStyle,
          ),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (!_venceu) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localPosition = renderBox.globalToLocal(
              details.globalPosition,
            );
            _onTouch(localPosition);
          }
        },
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: estiloContainerBody,
          child: CustomPaint(
            painter: _ContornoPainter(_imageLetra),
            child: SizedBox(height: double.infinity, width: double.infinity),
          ),
        ),
      ),
    );
  }
}

class _ContornoPainter extends CustomPainter {
  final ui.Image? imageLetra;

  _ContornoPainter(this.imageLetra);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageLetra != null) {
      final paint = Paint();
      final src = Rect.fromLTWH(
        0,
        0,
        imageLetra!.width.toDouble(),
        imageLetra!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawImageRect(imageLetra!, src, dst, paint);
    } else {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'A',
          style: TextStyle(color: Colors.black, fontSize: 250),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      final offset = Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _ContornoPainter oldDelegate) {
    return oldDelegate.imageLetra != imageLetra;
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}
