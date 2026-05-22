# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Update ComfyUI and install missing dependencies
RUN cd /comfyui && \
    git fetch --all && \
    git checkout master && \
    git pull origin master && \
    pip install --no-cache-dir -r requirements.txt

# ── Custom Nodes ─────────────────────────────────────────────────────────────

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    cd ComfyUI-KJNodes && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/TenStrip/10S-Comfy-nodes

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    cd rgthree-comfy && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/evanspearman/ComfyMath.git && \
    cd ComfyMath && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Comfy-Org/Nvidia_RTX_Nodes_ComfyUI && \
    cd Nvidia_RTX_Nodes_ComfyUI && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Lightricks/ComfyUI-LTXVideo && \
    cd ComfyUI-LTXVideo && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kosinkadink/ComfyUI-VideoHelperSuite && \
    cd ComfyUI-VideoHelperSuite && pip install -r requirements.txt

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/ClownsharkBatwing/RES4LYF && \
    cd RES4LYF && pip install -r requirements.txt

# ── Text Encoders ─────────────────────────────────────────────────────────────

RUN comfy model download \
    --url "https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors" \
    --relative-path models/text_encoders \
    --filename gemma_3_12B_it_fp8_e4m3fn.safetensors

# ── Checkpoints ───────────────────────────────────────────────────────────────

RUN comfy model download \
    --url "https://huggingface.co/TenStrip/LTX2.3-10Eros/resolve/main/10Eros_v1-fp8mixed_learned.safetensors?download=true" \
    --relative-path models/checkpoints \
    --filename 10Eros_v1-fp8mixed_learned.safetensors

# ── LoRAs ─────────────────────────────────────────────────────────────────────

RUN comfy model download \
    --url "https://huggingface.co/TenStrip/LTX2.3_Distilled_Lora_1.1_Experiments/resolve/main/ltx-2.3-22b-distilled-lora-1.1_fro90_ceil72_condsafe.safetensors" \
    --relative-path models/loras \
    --filename ltx-2.3-22b-distilled-lora-1.1_fro90_ceil72_condsafe.safetensors

RUN comfy model download \
    --url "https://huggingface.co/hfmaster/models-moved/resolve/main/ltx/LTX2.3_reasoning_I2V_V3.safetensors" \
    --relative-path models/loras \
    --filename LTX2.3_reasoning_I2V_V3.safetensors

RUN comfy model download \
    --url "https://huggingface.co/Alissonerdx/LTX-LoRAs/resolve/main/ltx23_edit_anything_global_rank128_v1_9000steps_adamw.safetensors" \
    --relative-path models/loras \
    --filename ltx23_edit_anything_global_rank128_v1_9000steps_adamw.safetensors

# ── Latent Upscale Models ─────────────────────────────────────────────────────

RUN comfy model download \
    --url "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors" \
    --relative-path models/latent_upscale_models \
    --filename ltx-2.3-spatial-upscaler-x2-1.0.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
