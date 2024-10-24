export const formatViews = (views) => {
  if (views >= 1000000) {
    return (views / 1000000).toFixed(1).replace(/\.0$/, '') + 'M'
  } else if (views >= 1000) {
    return (views / 1000).toFixed(1).replace(/\.0$/, '') + 'k'
  } else {
    return views.toString()
  }
}

export const formatFollowers = (views) => {
  if (views >= 1000000) {
    return (views / 1000000).toFixed(1).replace(/\.0$/, '') + 'M'
  } else if (views >= 1000) {
    return (views / 1000).toFixed(1).replace(/\.0$/, '') + 'k'
  } else {
    return views.toString()
  }
}
