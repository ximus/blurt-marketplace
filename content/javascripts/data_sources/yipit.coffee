class window.Yipit extends DataSource
  
  fetch: (callback) -> 
    items = []
    for deal in YipitSamples.response.deals
      item = new Item
      item.title = deal.yipit_title
      item.description = deal.title
      item.short_desc = deal.title
      item.image_url = deal.images.image_big
      item.end_date = Date.fromISO8601(deal.end_date)
      items.push item
    callback(items)