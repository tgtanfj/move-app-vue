const middlewarePipeline = (context, middleware, index = 1) => {
  const nextMiddleware = middleware[index]

  if (!nextMiddleware) return context.next

  return () => {
    const nextPipeline = middlewarePipeline(context, middleware, ++index)
    return nextMiddleware({ ...context, next: nextPipeline })
  }
}

export const applyMiddleware = async (to, from, next) => {
  const context = { to, from, next }
  const { middlewares: localMiddlewares = [] } = to.meta

  const globalMiddlewares = []
  const middlewares = [...globalMiddlewares, ...localMiddlewares]

  return middlewares[0]({
    ...context,
    next: middlewarePipeline(context, middlewares)
  })
}
