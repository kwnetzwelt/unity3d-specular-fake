using UnityEngine;
using System.Collections;

public class ForwardToMaterialProperty : MonoBehaviour
{
    public Renderer targetRenderer;
    public string propertyName;
    public Transform forwardTransform;

    public bool update = true;

    void Start()
    {
        UpdateForwardValue();
    }

    void Update ()
    {
        if (update)
        {
            UpdateForwardValue();
        }
	}

    public void UpdateForwardValue()
    {
        if (targetRenderer != null && forwardTransform != null)
        { 
            targetRenderer.material.SetVector(propertyName, forwardTransform.forward);
        }
    }

}
