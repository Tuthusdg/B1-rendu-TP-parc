# Partie I : Des beaux one liner

## 1. Intro

```bash
[unuser@node1 ~]$ free -mh | grep Mem | tr -s ' ' | cut -d' ' -f7
1.4Gi
```