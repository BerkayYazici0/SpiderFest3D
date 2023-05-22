using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnOrder : MonoBehaviour
{
    public float offsetX;
    public float offsetZ;
    public int orderOfSpawn = 0;

    public void spawnOrder()
    {
        offsetX += 0.75f;
        orderOfSpawn++;
        if (orderOfSpawn == 4)
        {
            orderOfSpawn = 0;
            offsetX = -1f;
            offsetZ -= 0.5f;
        }
    }
}
