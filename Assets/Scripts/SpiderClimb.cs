using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpiderClimb : MonoBehaviour
{
    [SerializeField] private GameObject[] spiders = new GameObject[4];
    [SerializeField] private GameObject[] bodyParts = new GameObject[4];
    [SerializeField] private GameObject[] turnBack = new GameObject[4];
    [SerializeField] private GameObject player;
    [SerializeField] private SpiderMovement spiderMovement;
    

    void Update()
    {
        //if (isReadyToClimb == true)
        //{
        //    if (spiders[0].transform.position == bodyParts[0].transform.position)
        //    {
        //        player.transform.position = new Vector3(player.transform.position.x, 0, player.transform.position.z);
        //        spiders[i].transform.position = Vector3.Lerp(spiders[i].transform.position, turnBack[i].transform.position, 0.1f);
        //    }
        //    else
        //    {
        //        for (int i = 0; i < 4; i++)
        //        {
        //            player.transform.position = new Vector3(player.transform.position.x, 0, player.transform.position.z);
        //            spiders[i].transform.position = Vector3.Lerp(spiders[i].transform.position, bodyParts[i].transform.position, 0.1f);
        //            spiders[i].transform.LookAt(bodyParts[i].transform);
        //        }
        //    }
        //}
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Spider"))
        {
            spiders = GameObject.FindGameObjectsWithTag("Spider");
            ClimbHuman();
        }
    }

    private void ClimbHuman()
    {
        for (int i = 0; i < 10; i++)
        {
            player.transform.position = new Vector3(player.transform.position.x, 0, player.transform.position.z);
            spiders[0].transform.position = Vector3.Lerp(spiders[0].transform.position, bodyParts[0].transform.position, 0.1f);
            spiders[1].transform.position = Vector3.Lerp(spiders[1].transform.position, bodyParts[1].transform.position, 0.1f);
            spiders[2].transform.position = Vector3.Lerp(spiders[2].transform.position, bodyParts[2].transform.position, 0.1f);
            spiders[3].transform.position = Vector3.Lerp(spiders[3].transform.position, bodyParts[3].transform.position, 0.1f);
            if(i == 9)
            {
                StartCoroutine(Wait());
                TurnBack();
            }
        }
        
    }

    private void TurnBack()
    {
        for (int i = 0; i < 10; i++)
        {
            player.transform.position = new Vector3(player.transform.position.x, 0, player.transform.position.z);
            spiders[0].transform.position = Vector3.Lerp(spiders[0].transform.position, turnBack[0].transform.position, 0.1f);
            spiders[1].transform.position = Vector3.Lerp(spiders[1].transform.position, turnBack[1].transform.position, 0.1f);
            spiders[2].transform.position = Vector3.Lerp(spiders[2].transform.position, turnBack[2].transform.position, 0.1f);
            spiders[3].transform.position = Vector3.Lerp(spiders[3].transform.position, turnBack[3].transform.position, 0.1f);
        }
        spiderMovement.speed = 6f;
        spiderMovement.leftRightSpeed = 6f;
    }
    
    IEnumerator Wait()
    {
        yield return new WaitForSeconds(2);
    }
}
