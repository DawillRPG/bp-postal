window.addEventListener('message', function(event) {
    var data = event.data;
    
    if (data.type === "showUI") {
        document.getElementById('postal-container').style.display = 'block';
    } else if (data.type === "updatePostal") {
        document.getElementById('postal-number').textContent = data.postal;
    }
}); 