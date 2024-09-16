from flask import Flask, request, jsonify, send_from_directory
import pytesseract
import cv2
import os

app = Flask(__name__)

# Defina o caminho do executável Tesseract-OCR
tesseract_cmd_path = r"D:\Program Files\Tesseract-OCR\tesseract.exe"
pytesseract.pytesseract.tesseract_cmd = tesseract_cmd_path

# Servir arquivos estáticos (CSS, JS)
@app.route('/<path:filename>')
def serve_static(filename):
    try:
        return send_from_directory('static', filename)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/')
def index():
    print("Acessando a rota principal /")
    return send_from_directory('static', 'webView.html')

@app.route('/extract-text', methods=['POST'])
def extract_text():
    if 'image' not in request.files:
        return jsonify({"error": "Nenhuma imagem foi enviada!"}), 400
    
    image_file = request.files['image']
    if image_file.filename == '':
        return jsonify({"error": "Arquivo inválido!"}), 400
    
    # Salvar a imagem temporariamente
    image_path = os.path.join("temp", image_file.filename)
    image_file.save(image_path)

    # Ler a imagem com OpenCV
    imagem = cv2.imread(image_path)

    # Extrair o texto da imagem com Pytesseract
    texto = pytesseract.image_to_string(imagem)

    # Remover a imagem temporária
    os.remove(image_path)

    return jsonify({"text": texto})

if __name__ == "__main__":
    if not os.path.exists('temp'):
        os.makedirs('temp')
    app.run(debug=True)
