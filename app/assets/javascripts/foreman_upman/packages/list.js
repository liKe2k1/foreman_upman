function activatePackageDataTable(el) {
    var $table = $(el).find('table');
    const url = $table.attr('data-source');
    $table.DataTable({
        processing: true,
        serverSide: true,
        lengthMenu: [ 15, 25, 50, 75, 100 ],
        ajax: url,
        columns: [
            {data: 'name'},
            {data: 'version'},
            {data: 'description'},
            {data: 'installed_size'},
            {
                data: null,
                render: function (data, type, row) {
                    return '<a href="/upman/packages/' + data.id + '" class="btn btn-primary">Details</a>'
                }
            }
        ]
    })
}

