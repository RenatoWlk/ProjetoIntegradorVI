function loadImage(event) {
    const imageDisplay = document.getElementById('imageDisplay');
    const file = event.target.files[0];
    const reader = new FileReader();

    reader.onload = function() {
        imageDisplay.src = reader.result;
        sendImageToServer(file);
    }

    if (file) {
        reader.readAsDataURL(file);
    }
}

function sendImageToServer(file) {
    const formData = new FormData();
    formData.append('image', file);

    fetch('/extract-text', {
        method: 'POST',
        body: formData,
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('textExtracted').textContent = data.text;
    })
    .catch(error => {
        console.error('Erro ao enviar a imagem para o servidor:', error);
    });
}
