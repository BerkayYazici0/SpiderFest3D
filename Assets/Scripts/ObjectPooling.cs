using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPooling : MonoBehaviour
{
    public static ObjectPooling SharedInstance;
    public List<GameObject> pooledObjects;
    public List<GameObject> activeObjects;
    public GameObject objectToPool;
    public int amountToPool;
    public GameObject player;

    void Awake()
    {
        SharedInstance = this;
    }

    void Start()
    {
        activeObjects.Add(player);
        pooledObjects = new List<GameObject>();
        GameObject tmp;

        for (int i = 0; i < amountToPool; i++)
        {
            tmp = Instantiate(objectToPool);
            tmp.transform.parent = player.transform;
            tmp.SetActive(false);
            pooledObjects.Add(tmp);
        }
    }

    private void Update()
    {

    }

    public GameObject GetPooledObject()
    {
        for (int i = 0; i < amountToPool; i++)
        {
            if (!pooledObjects[i].activeInHierarchy)
            {
                return pooledObjects[i];
            }
        }
        return null;
    }

    public void GetActiveSpiders()
    {
        foreach (var spiders in pooledObjects)
        {
            if(spiders.activeInHierarchy == true)
            {
                activeObjects.Add(spiders);
            }
            
        }
    }
}
