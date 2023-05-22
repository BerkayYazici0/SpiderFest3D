using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [SerializeField] private Transform spider;
    [SerializeField] private float smooth;
    [SerializeField] private Vector3 offset;

    private void Start()
    {
        offset = transform.position - spider.position;
    }

    private void Update()
    {
        Vector3 targetPos = spider.position + offset;
        Vector3 smoothedPos = Vector3.Lerp(transform.position, targetPos, smooth);
        transform.position = smoothedPos;

        var targetRot = Quaternion.Euler(spider.rotation.eulerAngles.x, spider.rotation.eulerAngles.y, spider.rotation.eulerAngles.z);
        transform.rotation = Quaternion.Lerp(transform.rotation, targetRot, smooth);
        
    }

}
