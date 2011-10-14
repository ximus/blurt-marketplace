$ = Zepto

class window.Yipit extends DataSource
  
  fetch: (callback) -> 
    $.ajax 
      url: '/deals/yipit?key=Q6ZmWjNvYQjBeYPD&limit=50', 
      success: (results) => @didFetch(results, callback),
      dataType: 'json'
    
  didFetch: (results, callback) ->
    # results = JSON.parse(results)
    items = []
    for deal in results.response.deals
      item = new Item
      item.title = deal.yipit_title
      item.description = deal.title
      item.short_desc = deal.title
      item.image_url = deal.images.image_big
      item.end_date = Date.fromISO8601(deal.end_date)
      items.push item
    callback(items)  