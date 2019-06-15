var updateInterval;

function updateSyncStatusView(uuid) {
    updateUi(uuid);
    updateInterval = setInterval(function() { updateUi(uuid); }, 5000);
}

function updateUi(uuid) {
    $.getJSON('/api/upman/repository/sync_status/?uuid=' + uuid, function (data) {
        percent = Math.round(data.packages_processed / data.packages_count * 100);

        $('#sync-status-text').html(percent + '% (' + data.packages_processed + ' von ' + data.packages_count + ' abgeschlossen)');
        $('#sync-current-package').html(data.last_package_name);
        $('#sync-status-progress').css('width', percent+ '%');
        $('#sync-status-progress').attr('aria-valuenow', percent);

        if (data.status == 'preparing') {

        }
        if (data.status == 'update') {

        }
        if (data.status == 'finished') {
            clearInterval(updateInterval);
        }
    });
}