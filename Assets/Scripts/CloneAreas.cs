using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneAreas : MonoBehaviour
{
    [SerializeField] private bool isMultiple;
    [SerializeField] private bool isPlus;
    [SerializeField] private bool isDestroy;
    [SerializeField] private GameObject player;
    [SerializeField] private List<GameObject> spiders;
    public int howManyCreate;
    public int numberOfAction;
    public ObjectPooling pool;
    public SpawnOrder spawnOrder;
    private GameObject spider;
    public bool isDying = false;
    void Start()
    {
        
    }
    void Update()
    {
        
    }

    public void Multiple()
    {
        howManyCreate = 0;
        if (pool.activeObjects.Count > 1)
            howManyCreate = numberOfAction * (pool.activeObjects.Count - 1);
        else
            howManyCreate = numberOfAction * pool.activeObjects.Count - 1;
        for (int i = 0; i < howManyCreate; i++)
        {
            spider = pool.GetPooledObject();
            spider.SetActive(true);
            spider.transform.position = new Vector3(player.transform.GetChild(1).transform.position.x + spawnOrder.offsetX, player.transform.GetChild(1).transform.position.y, player.transform.GetChild(1).transform.position.z + spawnOrder.offsetZ);            
            spawnOrder.spawnOrder();
        }
    }

    public void Plus()
    {
        howManyCreate = 0;
        howManyCreate = numberOfAction;
        for (int i = 0; i < howManyCreate; i++)
        {
            spider = pool.GetPooledObject();            
            spider.SetActive(true);  
            var followSpider = player.transform.GetChild(1).transform;          
            spider.transform.position = followSpider.position + followSpider.right * spawnOrder.offsetX + followSpider.forward * spawnOrder.offsetZ;
            spawnOrder.spawnOrder();            
        }
    }

    public void DestroySpider()
    {
        foreach (var spider in GameObject.FindGameObjectsWithTag("Spider"))
        {
            if(spider.activeInHierarchy == true)
                spiders.Add(spider);
        }
        spiders.Reverse();
        for(int i = 0; i < numberOfAction; i++)
        {
            spiders[i].GetComponent<ScaleTransformation>().SpiderDying();
            //spiders[i].SetActive(false);
            pool.activeObjects.Remove(spiders[i]);
        }           
        
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && isMultiple == true)
        {            
            Multiple();
            pool.GetActiveSpiders();
        }

        if (other.gameObject.CompareTag("Player") && isPlus == true)
        {
            Plus();
            pool.GetActiveSpiders();
        }
        if (other.gameObject.CompareTag("Player") && isDestroy == true)
        {
            DestroySpider();
        }
    }
    
}
