// var MAX_IMAGES = 1;
// var acceptedDimensions = {
//   width: 571,
//   height: 353,
// };

// function validateImage(file) {
//   var img = new Image();
//   img.onload = function () {
//     if (
//       img.width !== acceptedDimensions.width ||
//       img.height !== acceptedDimensions.height
//     ) {
//       alert(
//         "L'image " +
//           file.name +
//           " n'a pas les dimensions requises (" +
//           acceptedDimensions.width +
//           "x" +
//           acceptedDimensions.height +
//           ")."
//       );
//       return false;
//     }
//     return true;
//   };
//   img.src = URL.createObjectURL(file);
// }

// function handleFileSelect(files) {
//   if (files.length > MAX_IMAGES) {
//     alert("Vous ne pouvez sélectionner que " + MAX_IMAGES + " images.");
//     return;
//   }

//   for (var i = 0; i < files.length; i++) {
//     if (!validateImage(files[i])) {
//       return;
//     }
//   }

//   var fileInput = document.getElementById("myfiles");
//   fileInput.addEventListener("change", function () {
//     previewContainer.innerHTML = ""; // Effacer le contenu précédent

//     var files = fileInput.files;

//     for (var i = 0; i < files.length; i++) {
//       var reader = new FileReader();

//       reader.onload = function (e) {
//         var imgElement = document.createElement("img");
//         imgElement.src = e.target.result;
//         imgElement.className = "preview-image"; // Ajouter la classe

//         previewContainer.appendChild(imgElement);
//       };

//       reader.readAsDataURL(files[i]);
//     }
//   });
// }

// var fileInput = document.getElementById("myfiles");
// fileInput.addEventListener("change", handleFileSelect);




// document.addEventListener('DOMContentLoaded', function() {
//   var MAX_IMAGES = 10; // Adjusted to match your label
//   var acceptedDimensions = {
//       width: 571,
//       height: 353
//   };

//   function validateImage(file, callback) {
//       var img = new Image();
//       img.onload = function () {
//           if (img.width !== acceptedDimensions.width || img.height !== acceptedDimensions.height) {
//               alert("L'image " + file.name + " n'a pas les dimensions requises (" + acceptedDimensions.width + "x" + acceptedDimensions.height + ").");
//               callback(false);
//           } else {
//               callback(true);
//           }
//       };
//       img.src = URL.createObjectURL(file);
//   }

//   function handleFileSelect(event) {
//       var files = event.target.files;
//       var validFiles = [];

//       if (files.length > MAX_IMAGES) {
//           alert("Vous ne pouvez sélectionner que " + MAX_IMAGES + " images.");
//           return;
//       }

//       var previewContainer = document.getElementById("preview-container");
//       previewContainer.innerHTML = ""; // Clear previous content

//       var validationPromises = [];
//       for (var i = 0; i < files.length; i++) {
//           validationPromises.push(new Promise(function(resolve) {
//               validateImage(files[i], function(isValid) {
//                   if (isValid) {
//                       validFiles.push(files[i]);
//                   }
//                   resolve();
//               });
//           }));
//       }

//       Promise.all(validationPromises).then(function() {
//           for (var i = 0; i < validFiles.length; i++) {
//               var reader = new FileReader();
//               reader.onload = function (e) {
//                   var imgElement = document.createElement("img");
//                   imgElement.src = e.target.result;
//                   imgElement.className = "preview-image"; // Add class

//                   previewContainer.appendChild(imgElement);
//               };
//               reader.readAsDataURL(validFiles[i]);
//           }
//       });
//   }

//   var fileInput = document.getElementById("myfiles");
//   fileInput.addEventListener("change", handleFileSelect);
// });



document.addEventListener('DOMContentLoaded', function() {
    var MAX_IMAGES = 6; // Maximum d'images acceptées
    var acceptedDimensions = {
        width: 571, // Largeur attendue des images
        height: 353 // Hauteur attendue des images
    };

    // Fonction pour valider les dimensions de l'image
    function validateImage(file, callback) {
        var img = new Image();
        img.onload = function () {
            if (img.width !== acceptedDimensions.width || img.height !== acceptedDimensions.height) {
                // Redimensionner l'image aux dimensions acceptées
                resizeImage(file, acceptedDimensions.width, acceptedDimensions.height, function(resizedFile) {
                    callback(resizedFile);
                });
            } else {
                callback(file);
            }
        };
        img.src = URL.createObjectURL(file);
    }

    // Fonction pour redimensionner l'image
    function resizeImage(file, maxWidth, maxHeight, callback) {
        var img = new Image();
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');

        img.onload = function () {
            var width = img.width;
            var height = img.height;

            if (width > height) {
                if (width > maxWidth) {
                    height *= maxWidth / width;
                    width = maxWidth;
                }
            } else {
                if (height > maxHeight) {
                    width *= maxHeight / height;
                    height = maxHeight;
                }
            }

            canvas.width = width;
            canvas.height = height;

            ctx.drawImage(img, 0, 0, width, height);

            canvas.toBlob(function (blob) {
                var resizedFile = new File([blob], file.name, { type: 'image/jpeg' });
                callback(resizedFile);
            }, 'image/jpeg');
        };

        var reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    // Fonction pour gérer la sélection des fichiers
    function handleFileSelect(event) {
        var files = event.target.files;
        var validFiles = [];

        if (files.length > MAX_IMAGES) {
            alert("Vous ne pouvez sélectionner que " + MAX_IMAGES + " images.");
            return;
        }

        var previewContainer = document.getElementById("preview-container");
        previewContainer.innerHTML = ""; // Effacer le contenu précédent

        var validationPromises = [];
        for (var i = 0; i < files.length; i++) {
            validationPromises.push(new Promise(function(resolve) {
                validateImage(files[i], function(validatedFile) {
                    validFiles.push(validatedFile);
                    resolve();
                });
            }));
        }

        Promise.all(validationPromises).then(function() {
            for (var i = 0; i < validFiles.length; i++) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var imgElement = document.createElement("img");
                    imgElement.src = e.target.result;
                    imgElement.className = "preview-image"; // Ajouter la classe

                    previewContainer.appendChild(imgElement);
                };
                reader.readAsDataURL(validFiles[i]);
            }
        });
    }

    // Sélectionner le fichier et déclencher la gestion des fichiers lorsqu'ils sont modifiés
    var fileInput = document.getElementById("myfiles");
    fileInput.addEventListener("change", handleFileSelect);
});