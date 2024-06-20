$(document).ready(function() {
    // Initialiser les icônes de like en fonction de leur état
    $('.like-btn').each(function() {
        var isLiked = $(this).data('liked');
        var icon = $(this).children('i');
        if (isLiked == 'like') {
            icon.removeClass('far').addClass('fas liked');
        } else {
            icon.removeClass('fas liked').addClass('far');
        }
    });

    // Gérer les clics sur les boutons de like
    $('.like-btn').click(function() {
        var locationId = $(this).data('location-id');
        var maisonId = $(this).data('maison-id');
        var icon = $(this).children('i');
        var isLiked = icon.hasClass('fas');

        $.ajax({
            type: 'POST',
            url: '/like',
            contentType: 'application/json',
            data: JSON.stringify({ 
                'location_id': locationId,
                'maison_id': maisonId
            }),
            success: function(response) {
                if (isLiked) {
                    icon.removeClass('fas liked').addClass('far');
                } else {
                    icon.removeClass('far').addClass('fas liked');
                }
            },
            error: function(xhr, status, error) {
                console.error(error);
            }
        });
    });
});