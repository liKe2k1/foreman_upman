function activateHistoryDataTable(el) {
    var $table = $(el).find('table');
    const url = $table.attr('data-source');
    console.log(url)

    $table.DataTable({
        processing: true,
        serverSide: true,
        lengthMenu: [ 15, 25, 50, 75, 100 ],
        ajax: url,
        order: [[ 3,  "desc" ]],
        columns: [
            {data: 'package'},
            {data: 'action'},
            {
                data: null,
                render: function (data, type, row) {
                    if (data.action == 'install') {
                        return '<i class="text-success fa fa-plus"></i> ' + data.target_version
                    }
                    if (data.action == 'upgrade') {
                        return '<i class="text-warning fa fa-minus"></i> ' + data.old_version + ' >> <i class="text-success fa fa-plus"></i>  ' + data.target_version
                    }

                    if (data.action == 'remove') {
                        return '<i class="text-warning fa fa-minus"></i> ' + data.old_version
                    }

                }
            },
            {data: 'created_at'},
            {
                data: null,
                render: function (data, type, row) {
                    return '<a href="/upman/packages/' + data.id + '" class="btn btn-primary">Details</a>'
                }
            }
        ]
    })
}

