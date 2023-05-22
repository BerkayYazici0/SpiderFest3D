using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleTransformation : MonoBehaviour
{
    public Animator spiderAnim;
    private void Update()
    {
    }

    public void PlayAnim()
    {
        if(gameObject.tag != "Player")
            spiderAnim.SetTrigger("isCreating");
    }

    public void SpiderDying()
    {
        spiderAnim.SetTrigger("isDying");
    }
    
}
