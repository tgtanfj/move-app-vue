export const convertRepsToUSD = (reps) => {
  const rate = 0.006
  const usd = reps * rate
  return usd.toFixed(2)
}