
$(document).on('ContentLoad', function() {
    $('a[data-toggle="tab"]').on('click', function(e) {
        history.pushState(null, null, document.location.pathname + $(this).attr('href'));
    });
    setTab();
});

$(window).on('hashchange', setTab); //so buttons that link to an anchor can open that tab
// Make sure the correct tab is displayed when loading the page with an anchor,
// even if the anchor is to a sub-tab.
function setTab(){
    var anchor = document.location.hash.split('?')[0];
    if (anchor.length) {
        var parent_tab = $(anchor).parents('.tab-pane');
        if (parent_tab.exists()){
            $('.nav-tabs a[href="#'+parent_tab[0].id+'"]').tab('show');
        }
        $('.nav-tabs a[href="'+anchor+'"]').tab('show');
    }
}