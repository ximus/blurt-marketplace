class window.Item
  title: null,
  image_url: null,
  description: null,
  short_desc: null,
  end_date: null,

  # NOTE: this could be cached
  time_left: =>
    difference = Date.timeDifference(@end_date, Date.now)  