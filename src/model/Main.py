import os
from flask import Flask, render_template, request, jsonify
import pytesseract
import cv2

# Configurando o Flask p pegar os arquivos nas pastas certas
app = Flask(__name__,
            template_folder=os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', 'templates'),
            static_folder=os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', 'static'))

# Definir o caminho do Tesseract-OCR
tesseract_cmd_path = r"D:\Program Files\Tesseract-OCR\tesseract.exe"
pytesseract.pytesseract.tesseract_cmd = tesseract_cmd_path

# Criação do diretório temp p deixar as fotos temporaria e usar menos memoria
temp_dir = os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', 'temp')
if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

# Rota principal p mostrsa o arquivo webView.html
@app.route('/')
def index():
    print("Acessando a rota principal /")
    return render_template('webView.html')

# Rota para extrair o texto da imagem
@app.route('/extract-text', methods=['POST'])
def extract_text():
    if 'image' not in request.files:
        return jsonify({"error": "Nenhuma imagem foi enviada!"}), 400
    
    image_file = request.files['image']
    if image_file.filename == '':
        return jsonify({"error": "Arquivo inválido!"}), 400
    
    # Salvar a imagem temporariamente
    image_path = os.path.join(temp_dir, image_file.filename)
    image_file.save(image_path)

    # Ler a imagem com OpenCV
    imagem = cv2.imread(image_path)

    # Extrair o texto da imagem com Pytesseract
    texto = pytesseract.image_to_string(imagem)

    # Remover a imagem temporária
    os.remove(image_path)

    return jsonify({"text": texto})

if __name__ == "__main__":
    app.run(debug=True)
