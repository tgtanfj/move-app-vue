import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { AwsS3Service } from '../services/aws-s3.service';
import { VideoService } from '@/modules/video/video.service';
import { Logger } from '@nestjs/common';
@Processor('upload-s3')
export class UploadS3Processor extends WorkerHost {
  private logger = new Logger();
  constructor(
    private readonly s3: AwsS3Service,
    private readonly videoService: VideoService,
  ) {
    super();
  }
  async process(job: Job, token?: string): Promise<any> {
    switch (job.name) {
      case 'upload':
        const s3Url = await this.s3.uploadVideo(job.data.file);
        console.log(s3Url);
        return await this.videoService.uploadVideoUrlS3(job.data.videoId, s3Url);
      default:
        throw new Error('No job name match');
    }
  }
  async optimizeImage(image: unknown) {
    this.logger.log('Processing image....');
    return await new Promise((resolve) => setTimeout(() => resolve(image), 30000));
  }
}
