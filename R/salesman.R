##  GPL-3 License
## Copyright (c) 2019 Vincent Runge

#' Towns coordinate generator
#'
#' @description Genearting towns coordinate using a standard normal distribution
#' @param n number of towns to generate
#' @return a dataframe with 2 columns X et Y with the town coordinates
Towns <- function(n = 7)
{
  return(data.frame(X=rnorm(n), Y = rnorm(n)))
}


#' Euclidean distance between two 2d points
#'
#' @description Computing L2 distance between 2 points
#' @param v1 first (X1,Y1) point
#' @param v2 second (X1,Y1) point
#' @return a number = sqrt((X1-X2)^2 + (Y1-Y2)^2)
distance <- function(v1, v2)
{
  D <- sqrt(sum((v1-v2)^2))
  return(D)
}


#' The shortest route in the travelling salesman problem
#'
#' @description This algorithms returns the indices of towns in the shortest order for the Euclidean norm
#' @param towns dataframe of towns generated by the `Towns` function
#' @return vector of town indices of the shortest path
monVoyageR <- function(towns)
{
  n <- dim(towns)[1]
  distance <- Inf
  res <- NULL
  voyages <- permn(2:n)

  nbLoops <- factorial(n-1)
  for(i in 1:nbLoops)
  {
    Voy <- c(1,unlist(voyages[i]),1)
    D <- 0
    for(i in 1:n){D <- D + distance(towns[Voy[i],],towns[Voy[i+1],])}
    if(D < distance)
    {
      res <- Voy
      distance <- D
    }
  }
  attr(res, "class") <- "salesman"
  return(res)
}


#' A naive algorithm in the travelling salesman problem
#'
#' @description This algorithms returns the indices of towns with a simple closest-town strategy
#' @param towns dataframe of towns generated by the `Towns` function
#' @return vector of town indices of the naive strategy
monVoyageClosest <- function(towns)
{
  n <- dim(towns)[1]
  indices <- 2:n
  res <- 1

  for(i in 1:(n-2))
  {
    D <- Inf
    ind <- NULL
    for(j in indices)
    {
      if(distance(towns[res[1],],towns[j,]) < D)
      {
        D <- distance(towns[res[1],],towns[j,])
        ind <- j
      }
    }
    res <- c(ind,res)
    indices <- indices[indices!= ind]
  }
  res <- rev(c(1,indices,res))
  attr(res, "class") <- "salesman"
  return(res)
}
