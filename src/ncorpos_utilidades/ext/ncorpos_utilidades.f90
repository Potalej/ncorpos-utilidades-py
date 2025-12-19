module ncorpos_utilidades
  use utilidades
  use tipos
  implicit none

contains

subroutine teste (u, v)
  real(8), dimension(3), intent(in) :: u, v
  real(8), dimension(3) :: w

  w = produto_vetorial(u,v)
  write (*,*) 'produto vetorial: ', w
end subroutine

end module