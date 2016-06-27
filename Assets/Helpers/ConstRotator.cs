using UnityEngine;
using System.Collections;

public class ConstRotator : MonoBehaviour
{
    public Vector3 axis;
    public float speed;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        this.transform.RotateAround(axis, speed * Time.deltaTime);
    }
}
