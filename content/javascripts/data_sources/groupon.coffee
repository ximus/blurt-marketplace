$ = Zepto

class window.Groupon extends DataSource
  
  fetch: (callback) -> 
    $.ajax 
      url: '/deals/groupon?client_id=1a084a51f3532d8f36f99285f77642bbd156526b&division_id=chicago&show=title,announcementTitle,endAt,largeImageUrl', 
      success: (results) => @didFetch(results, callback),
      dataType: 'json'
    
  didFetch: (results, callback) ->
    # results = JSON.parse(results)
    items = []
    for deal in results.deals
      item = new Item
      item.title = deal.announcementTitle
      item.description = deal.title
      item.short_desc = deal.title
      item.image_url = deal.largeImageUrl
      item.end_date = Date.fromISO8601(deal.endAt)
      items.push item
    callback(items)