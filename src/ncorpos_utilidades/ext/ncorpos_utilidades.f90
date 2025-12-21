MODULE ncorpos_utilidades
  USE utilidades
  IMPLICIT NONE
  PUBLIC
CONTAINS

SUBROUTINE teste (u, v)
  REAL(8), DIMENSION(3), INTENT(IN) :: u, v
  REAL(8), DIMENSION(3) :: w

  w = produto_vetorial(u,v)
  write (*,*) 'produto vetorial: ', w
END SUBROUTINE

FUNCTION py_energia_cinetica (massas, momentos) RESULT(ec)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: momentos
  REAL(8) :: ec

  ec = energia_cinetica_vec(massas, momentos)
END FUNCTION

FUNCTION py_momento_angular_individual (posicao, momento) RESULT(J)
  REAL(8), DIMENSION(:), INTENT(IN) :: posicao, momento
  REAL(8), DIMENSION(3) :: J

  J = momento_angular_individual(posicao, momento)
END FUNCTION

FUNCTION py_momento_angular_total (posicoes, momentos) RESULT(J)
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes, momentos
  REAL(8), DIMENSION(3) :: J

  J = momento_angular_total(posicoes, momentos)
END FUNCTION

FUNCTION py_energia_potencial (G, massas, posicoes, eps) RESULT(V)
  REAL(8), INTENT(IN)                 :: G, eps
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: V

  V = energia_potencial_vec(G, massas, posicoes, eps)
END FUNCTION

FUNCTION py_energia_total (G, massas, posicoes, momentos, eps) RESULT(E)
  REAL(8), INTENT(IN)                 :: G, eps
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes, momentos
  REAL(8) :: E

  E = energia_total_vec(G, massas, posicoes, momentos, eps)
END FUNCTION

FUNCTION py_momento_dilatacao (posicoes, momentos) RESULT(D)
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes, momentos
  REAL(8) :: D

  D = momento_dilatacao(posicoes, momentos)
END FUNCTION

FUNCTION py_momento_inercia (massas, posicoes) RESULT(I)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: I

  I = momento_inercia_vec(massas, posicoes)
END FUNCTION

FUNCTION py_raio_meia_massa (massas, posicoes) RESULT(r_mh)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: r_mh

  r_mh = raio_meia_massa(massas, posicoes)
END FUNCTION

FUNCTION py_tempo_relaxacao_rh (massas, posicoes) RESULT(t_mh)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: t_mh

  t_mh = tempo_relaxacao_rh(massas, posicoes)
END FUNCTION

FUNCTION py_virial_potencial_amortecido (G, massas, posicoes, eps) RESULT(Fq)
  REAL(8), INTENT(IN)                 :: G, eps
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: Fq

  Fq = virial_potencial_amortecido(G, massas, posicoes, eps)
END FUNCTION

FUNCTION py_tensor_inercia_individual (massa, posicao) RESULT(Ia)
  REAL(8), INTENT(IN)   :: massa
  REAL(8), DIMENSION(:), INTENT(IN) :: posicao
  REAL(8), DIMENSION(3,3) :: Ia

  Ia = tensor_inercia(massa, posicao)
END FUNCTION

FUNCTION py_tensor_inercia_geral (massas, posicoes) RESULT(I)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8), DIMENSION(3,3) :: I

  I = tensor_inercia_geral(massas, posicoes)
END FUNCTION

FUNCTION py_centro_massas (massas, posicoes) RESULT(rcm)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8), DIMENSION(3)               :: rcm

  rcm = centro_massas(massas, posicoes)
END FUNCTION

FUNCTION py_momento_linear_total (momentos) RESULT(P)
  REAL(8), DIMENSION(:,:), INTENT(IN) :: momentos
  REAL(8), DIMENSION(3)               :: P

  P = momento_linear_total(momentos)
END FUNCTION

FUNCTION py_anisotropia_tensor_inercia (massas, posicoes) RESULT(A)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes
  REAL(8) :: A

  A = anisotropia_tensor_inercia(massas, posicoes)
END FUNCTION

FUNCTION py_anisotropia_velocidades (massas, posicoes, momentos) RESULT(Av)
  REAL(8), DIMENSION(:),   INTENT(IN) :: massas
  REAL(8), DIMENSION(:,:), INTENT(IN) :: posicoes, momentos
  REAL(8) :: Av

  Av = anisotropia_velocidades(massas, posicoes, momentos)
END FUNCTION

END MODULE