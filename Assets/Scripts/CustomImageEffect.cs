using UnityEngine;

[ExecuteInEditMode]
public class CustomImageEffect : MonoBehaviour
{

    public Material material;
    private void Start()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
       
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, material);
    }
}