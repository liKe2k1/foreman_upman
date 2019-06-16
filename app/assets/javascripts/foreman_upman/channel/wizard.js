var $base_url;
var $codename;

$(document).on('ContentLoad', function () {

    $base_url = $('#channel_base_url')
    $codename = $('#channel_dist_code')

    $base_url.on('keyup', function () {
        _firstStepChecker($base_url, $codename)
    });
    $codename.on('keyup', function () {
        _firstStepChecker($base_url, $codename)
    });

});


function _firstStepChecker(base_url, codename) {
    if (/^(http|https|ftp):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i.test(base_url.val()) && codename.val() !== '') {
        $('#btn-trigger-lookup').removeClass('disabled');
    } else {
        $('#btn-trigger-lookup').addClass('disabled');
    }

}

function lookupRepository() {
    $('#btn-trigger-lookup').addClass('disabled');
    $('#lookup-process-failed').hide();
    $('#repository-details').hide();
    $('#lookup-process').show();

    api_endpoint = '/api/upman/repository/lookup/?base_url=' + encodeURIComponent($base_url.val()) + '&codename=' + $codename.val();
    $.getJSON(api_endpoint, function (data) {
        console.log(data);

        $('#lookup-process').hide();
        $('#dt-release-data').html('')
            .append($('<tr />').append($('<td />').html('Origin'), $('<td />').html(data.origin)))
            .append($('<tr />').append($('<td />').html('Codename'), $('<td />').html(data.codename)))
            .append($('<tr />').append($('<td />').html('Suite'), $('<td />').html(data.suite)))
            .append($('<tr />').append($('<td />').html('Version'), $('<td />').html(data.version)))
            .append($('<tr />').append($('<td />').html('Description'), $('<td />').html(data.description)))
            .append($('<tr />').append($('<td />').html('Repository-URL'), $('<td />').html(data.base_url + '/' + data.codename)));


        $(data.architectures).each(function (idx, value) {
            option = $('<option />').val(value).html(value);
            if (value == 'amd64') {
                option.prop('selected')
            }
            $('#arch-selector').append(option);
        });

        $(data.components).each(function (idx, value) {
            $('#component-selector').append($('<option />').val(value).html(value));
        });


        $('#repository-details').show();
    }).error(function () {
        $('#lookup-process-failed').show();
        $('#lookup-process').hide();

    })
}