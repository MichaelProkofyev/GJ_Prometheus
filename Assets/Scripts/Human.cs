using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Human : MonoBehaviour {

    public Renderer renderer;

    float timer = 0;

	
	// Update is called once per frame
	void Update ()
    {
        return;
        if (timer > .5f)
        {
            float randomX = Random.Range(0f, 1f);
            float randomY = Random.Range(0f, 1f);
            renderer.sharedMaterial.SetVector("_FlashPosition", new Vector4(randomX, randomY, 0, 0));
            renderer.sharedMaterial.SetFloat("FlashPosition2", randomX);
            timer = 0;
            print(randomX + " " + randomY);       
        }
        else
        {
            timer += Time.deltaTime;
        }
    }
}