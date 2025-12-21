import ncorpos_utilidades as nut
import numpy as np
import pytest

@pytest.fixture
def sistemas ():
  Ns = [1,2,3,10,20]
  infos = {"Ns": Ns, "massas": dict(), "posicoes": dict(), "momentos": dict()}
  
  # faz os sorteios
  for N in Ns:
    massas = np.random.random(N)
    while min(massas) <= 1e-8: massas = np.random.random(N)
    infos["massas"][N] = massas
    infos["posicoes"][N] = np.random.randn(N,3)
    infos["momentos"][N] = np.random.randn(N,3)

  return infos

def test_energia_cinetica (sistemas):
  for N in sistemas["Ns"]:
    massas = sistemas["massas"][N]
    momentos = sistemas["momentos"][N]

    ec_esperada = 0.0
    for a in range(N):
      ec_esperada += 0.5 * (momentos[a] @ momentos[a]) / massas[a]
    
    ec = nut.energia_cinetica(massas, momentos)
    assert np.allclose(ec, ec_esperada, rtol=1e-12), "Energia cinética deu errado."

def test_momento_angular_total (sistemas):
  for N in sistemas["Ns"]:
    posicoes = sistemas["posicoes"][N]
    momentos = sistemas["momentos"][N]

    J_esperado = np.zeros(3, dtype=float)
    for a in range(N):
      J_esperado += np.cross(posicoes[a], momentos[a])
    
    J = nut.momento_angular_total(posicoes, momentos)
    assert np.allclose(J_esperado, J, rtol=1e-12), "Momento angular total deu errado."

