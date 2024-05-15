import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener("DOMContentLoaded", function() {
    function previewImage(event) {
      const input = event.target;
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
          const preview = document.getElementById('image-preview');
          preview.src = e.target.result;
        }
        reader.readAsDataURL(input.files[0]);
      }
    }
  
    const fileInput = document.getElementById('image_url_path');
    if (fileInput) {
      fileInput.addEventListener('change', previewImage);
    }
  });