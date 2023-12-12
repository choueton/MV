// function applyFilters() {
//     // Get filter values
//     var ville = document.getElementById('ville').value;
//     var commune = document.getElementById('commune').value;
//     var nombre_de_pieces = document.getElementById('nombre_de_pieces').value;
//     var prix_min = document.getElementById('Prix_mensuel').value;
//     var prix_max = document.getElementById('Prix_mensuel').value;

//     // Use AJAX to send filter values to the server
//     var xhr = new XMLHttpRequest();
//     xhr.open('POST', '/loue_maison', true);
//     xhr.setRequestHeader('Content-Type', 'application/json');
//     xhr.onreadystatechange = function () {
//         if (xhr.readyState == 4 && xhr.status == 200) {
//             // Update the content with the filtered results
//             document.getElementById('filtered-results').innerHTML = xhr.responseText;
//         }
//     };

//     // Send filter values as JSON to the server
//     var data = {
//         ville: ville,
//         commune: commune,
//         nombre_de_pieces: nombre_de_pieces,
//         prix_min: prix_min,
//         prix_max: prix_max
//     };
//     xhr.send(JSON.stringify(data));
// }



function applyFilters() {
    // Get filter values
    var villeElement = document.getElementById("ville");
    var communeElement = document.getElementById("commune");
    var nombreDePiecesElement = document.getElementById("nombre_de_pieces");
    var prixMinElement = document.getElementById("prix_min");
    var prixMaxElement = document.getElementById("prix_max");
  
    // Check if elements exist before accessing their values
    if (villeElement && communeElement && nombreDePiecesElement && prixMinElement && prixMaxElement) {
      var ville = villeElement.value;
      var commune = communeElement.value;
      var nombre_de_pieces = nombreDePiecesElement.value;
      var prix_min = prixMinElement.value;
      var prix_max = prixMaxElement.value;
  
      // Use AJAX to send filter values to the server
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/loue_maison", true);
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
          // Check if the element with ID "filtered-results" exists
          var filteredResultsElement = document.getElementById("filtered-results");
          if (filteredResultsElement) {
            // Update the content with the filtered results
            filteredResultsElement.innerHTML = xhr.responseText;
          } else {
            console.error("Element with ID 'filtered-results' not found.");
          }
        }
      };
  
      // Send filter values as JSON to the server
      var data = {
        ville: ville,
        commune: commune,
        nombre_de_pieces: nombre_de_pieces,
        prix_min: prix_min,
        prix_max: prix_max,
      };
      xhr.send(JSON.stringify(data));
    } else {
      console.error("One or more elements not found.");
    }
  }
  