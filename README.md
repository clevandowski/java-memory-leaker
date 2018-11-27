# Prérequis

Debian/Ubuntu: Support de la limite de la swap par le kernel

Si vous avez au démarrage du container un message du genre:

```
WARNING: Your kernel does not support swap limit capabilities. Limitation discarded.
```

ou bien

```
WARNING: Your kernel does not support swap limit capabilities or the cgroup is not mounted. Memory limited without swap.
```

Alors suivez le guide:
https://docs.docker.com/install/linux/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities

# Récupérer les paramètres mémoire/swap d'un container

```
$ docker container inspect lucid_blackwell | jq  ".[0].HostConfig | { Memory: .Memory, MemorySwap: .MemorySwap, MemorySwappiness: .MemorySwappiness }"
{
  "Memory": 268435456,
  "MemorySwap": -1,
  "MemorySwappiness": null
}
```
