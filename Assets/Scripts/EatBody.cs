using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EatBody : MonoBehaviour
{
    [SerializeField] private SpiderMovement spiderMovement;
    [SerializeField] private Animator playerAnim;
    private bool isSpider = false;
    private void Start()
    {
            
    }

    private void Update()
    {
        if(isSpider == true)
        {
            playerAnim.SetBool("isDead", true);
            if(transform.GetChild(0).transform.GetChild(1).transform.GetComponent<SkinnedMeshRenderer>().material.GetFloat("_DissolveFX") < 1f)
                StartCoroutine(DissolveFX());
            isSpider = false;            
        }        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Spider"))
        {
            isSpider = true;
            spiderMovement.speed = 0f;
            spiderMovement.leftRightSpeed = 0f;
            
        }
    }

    private IEnumerator DissolveFX()
    {
        var timer = 0f;
        while (timer < 1f)
        {            
            timer += 0.1f;
            yield return new WaitForSeconds(0.1f);
            transform.GetChild(0).transform.GetChild(1).transform.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_DissolveFX", timer);
        }
        yield return null;
    }
}
