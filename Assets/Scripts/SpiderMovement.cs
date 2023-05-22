using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class SpiderMovement : MonoBehaviour
{
    public float speed;
    public float leftRightSpeed;
    [SerializeField] private float startPos;
    [SerializeField] private float curPos;
    [SerializeField] private float smooth;

    void Start()
    {
        
    }

    void Update()
    {
        transform.Translate(Vector3.forward * speed * Time.deltaTime);
        
        if (Input.GetMouseButtonDown(0))
        {
            leftRightSpeed = 6f;
            startPos = Camera.main.ScreenToViewportPoint(Input.mousePosition).x;
        }

        if (Input.GetMouseButton(0))
        {
            leftRightSpeed = 6f;
            curPos = Camera.main.ScreenToViewportPoint(Input.mousePosition).x;
        }

        if (Input.GetMouseButtonUp(0))
        {
            leftRightSpeed = 0f;
        }

        if(curPos > startPos)
        {
            transform.Translate(Vector3.right * leftRightSpeed * Time.deltaTime);
        }
        else if(curPos < startPos )
        {
            transform.Translate(Vector3.left * leftRightSpeed * Time.deltaTime);
        }
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
        {
            other.gameObject.SetActive(false);
            var targetRot = Quaternion.Euler(other.transform.eulerAngles.x, other.transform.eulerAngles.y, other.transform.eulerAngles.z);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRot, smooth);
        }
    }
}
